# Roda com: rails runner db/scripts/resequence_ids_auto.rb
# BACKUP ANTES DE RODAR (p.ex. pg_dump)
#
# Este script:
#  - trabalha em transaction
#  - detecta todas as FKs que apontam para cada tabela alvo
#  - cria map temporário old_id -> new_id (row_number ordenado por id)
#  - aplica ids negativos temporariamente para evitar violação de FK
#  - atualiza colunas FK para os ids negativos correspondentes
#  - torna os ids positivos novamente e ajusta sequences
#
# TARGETS: categorias (categories), vacinas (products), hubs

ActiveRecord::Base.transaction do
  conn = ActiveRecord::Base.connection

  target_tables = %w[categories products hubs]

  # Todas as tabelas do schema público (exclui internas)
  all_tables = conn.tables

  target_tables.each do |table|
    puts "-> Resequenciando #{table}..."

    tmp = "tmp_#{table}_map"

    # 1) encontrar todas as FKs que referenciam `table`
    referencing = []

    all_tables.each do |t|
      next if t == table
      conn.foreign_keys(t).each do |fk|
        if fk.to_table == table
          referencing << { from_table: t, column: fk.options[:column] || fk.column }
        end
      end
    end

    # também incluir self-references (se houver FK dentro da própria tabela)
    conn.foreign_keys(table).each do |fk|
      if fk.to_table == table
        referencing << { from_table: table, column: fk.options[:column] || fk.column }
      end
    end

    # 2) cria temp map e aplica atualizações
    quoted_table = conn.quote_table_name(table)

    # drop temp if exists just in case
    conn.execute("DROP TABLE IF EXISTS #{conn.quote_table_name(tmp)}")

    # create temp map
    conn.execute(<<-SQL.squish)
      CREATE TEMP TABLE #{conn.quote_table_name(tmp)} AS
        SELECT id AS old_id, row_number() OVER (ORDER BY id) AS new_id FROM #{quoted_table};
    SQL

    # update main table ids -> negative new ids
    conn.execute(<<-SQL.squish)
      UPDATE #{quoted_table} t
      SET id = -m.new_id
      FROM #{conn.quote_table_name(tmp)} m
      WHERE t.id = m.old_id;
    SQL

    # update all referencing tables' fk columns -> negative new ids
    referencing.each do |r|
      from = conn.quote_table_name(r[:from_table])
      col = conn.quote_column_name(r[:column])
      conn.execute(<<-SQL.squish)
        UPDATE #{from} rt
        SET #{col} = -m.new_id
        FROM #{conn.quote_table_name(tmp)} m
        WHERE rt.#{col} = m.old_id;
      SQL
    end

    # turn main ids positive
    conn.execute(<<-SQL.squish)
      UPDATE #{quoted_table} SET id = -id;
    SQL

    # turn referencing fk columns positive (only negative values)
    referencing.each do |r|
      from = conn.quote_table_name(r[:from_table])
      col = conn.quote_column_name(r[:column])
      conn.execute(<<-SQL.squish)
        UPDATE #{from}
        SET #{col} = -#{col}
        WHERE #{col} < 0;
      SQL
    end

    # reset sequence for the table's id
    conn.execute(<<-SQL.squish)
      SELECT setval(pg_get_serial_sequence(#{conn.quote(table)}, 'id'), (SELECT COALESCE(MAX(id),0) FROM #{quoted_table}));
    SQL

    # drop temp map
    conn.execute("DROP TABLE IF EXISTS #{conn.quote_table_name(tmp)}")

    puts "   -> concluído #{table}."
  end

  puts "Re-sequenciamento completo."
end