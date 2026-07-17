class CreatePhysicalExams < ActiveRecord::Migration[7.0]
  def change
    create_table :physical_exams do |t|
      t.references :emergency, null: false, foreign_key: true
      t.text :cabeza
      t.text :ojo
      t.text :cuello
      t.text :orl
      t.text :torax
      t.text :cardiovascular
      t.text :abdomen
      t.text :genitales
      t.text :extremidades
      t.text :neurologico
      t.timestamps
    end
  end
end
