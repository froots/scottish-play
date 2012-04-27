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

ActiveRecord::Schema.define(:version => 20120427114719) do

  create_table "acts", :force => true do |t|
    t.integer  "number"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "characters", :force => true do |t|
    t.string   "char_id"
    t.string   "name"
    t.integer  "speech_count"
    t.string   "short_name"
    t.text     "description"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "lines", :force => true do |t|
    t.integer  "number"
    t.text     "text"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "paragraph_id"
  end

  create_table "paragraphs", :force => true do |t|
    t.string   "paragraph_type"
    t.integer  "section"
    t.text     "phonetic"
    t.integer  "word_count"
    t.integer  "char_count"
    t.integer  "chapter"
    t.text     "stem_text"
    t.integer  "paragraph_id"
    t.integer  "number"
    t.integer  "scene_id"
    t.integer  "character_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "scenes", :force => true do |t|
    t.integer  "number"
    t.integer  "act_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
