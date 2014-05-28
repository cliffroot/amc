# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130520135750) do

  create_table "distributors", :force => true do |t|
    t.string   "name"
    t.string   "formula_price"
    t.string   "formula_del_uae"
    t.string   "formula_del_eu"
    t.integer  "column_code"
    t.integer  "column_price"
    t.integer  "column_weight"
    t.integer  "column_amount"
    t.integer  "column_description"
    t.integer  "column_koef"
    t.integer  "column_pg"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "rg"
  end

  create_table "manufacturers", :force => true do |t|
    t.string   "name"
    t.integer  "distributor_id"
    t.datetime "last_price_update"
  end

  create_table "products", :force => true do |t|
    t.string  "code"
    t.string  "price"
    t.string  "weight"
    t.integer "amount"
    t.text    "description"
    t.integer "manufacturer_id"
    t.integer "distributor_id"
    t.string  "route"
    t.string  "rg"
  end

  add_index "products", ["code"], :name => "index_products_on_code"

  create_table "rgs", :force => true do |t|
    t.string   "manufacturer"
    t.string   "code"
    t.float    "value"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "vars", :force => true do |t|
    t.string   "name"
    t.float    "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
