ActiveRecord::Schema.define(:version => 1) do
  
  create_table :people, :force => true do |t|
    t.column :phone, :string
  end
end