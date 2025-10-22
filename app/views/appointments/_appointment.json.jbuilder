json.extract! appointment, :id, :patient_name, :appointment_date, :address, :status, :technician_name, :hub_id, :user_id, :created_at, :updated_at
json.url appointment_url(appointment, format: :json)
