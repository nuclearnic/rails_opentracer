ActiveRecord::Schema.define do
  create_table(:pages, force: true) do |t|
    t.string :name
    t.text   :content
    t.timestamps
  end
  Page.create(name: 'Page name', content: 'Page content')
end
