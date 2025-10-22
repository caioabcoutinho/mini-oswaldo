class StockItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    @hub = Hub.find(params[:hub_id])
    
    product_id = stock_item_params[:product_id]
    quantity_to_change = stock_item_params[:quantity].to_i
    operation = params[:operation] # 'add' ou 'remove'

    if product_id.blank? || quantity_to_change <= 0
      redirect_to @hub, alert: "Por favor, selecione um produto e uma quantidade positiva."
      return
    end

    existing_stock_item = @hub.stock_items.find_by(product_id: product_id)

    if operation == 'add'
      handle_addition(existing_stock_item, product_id, quantity_to_change)
    elsif operation == 'remove'
      handle_removal(existing_stock_item, quantity_to_change)
    else
      redirect_to @hub, alert: "Operação inválida."
    end
  end

  private

  def handle_addition(stock_item, product_id, quantity)
    if stock_item
      stock_item.increment!(:quantity, quantity)
    else
      @hub.stock_items.create(product_id: product_id, quantity: quantity)
    end
    redirect_to @hub, notice: "Estoque adicionado com sucesso!"
  end

  def handle_removal(stock_item, quantity)
    if stock_item.nil?
      redirect_to @hub, alert: "Não é possível remover estoque de um produto que não existe no hub."
      return
    end

    if stock_item.quantity < quantity
      redirect_to @hub, alert: "Não é possível remover mais itens do que o existente em estoque (#{stock_item.quantity} unidades)."
      return
    end

    stock_item.with_lock do
      new_qty = stock_item.quantity - quantity
      if new_qty <= 0
        stock_item.destroy!
      else
        stock_item.update!(quantity: new_qty)
      end
    end

    redirect_to @hub, notice: "Estoque removido com sucesso!"
  end

  def stock_item_params
    params.require(:stock_item).permit(:product_id, :quantity)
  end
end