# frozen_string_literal: true

require_relative 'active_crud/version'
require 'will_paginate'

module ActiveCrud
  class Error < StandardError; end

  def self.create_record(model, record_params)
    record = model.new(record_params)

    if record.save
      { message: 'Record created successfully', record: record }
    else
      { error: 'Failed to create record', errors: record.errors }
    end
  end

  def self.retrieve_all_records(model)
    model.all
  end

  def self.retrieve_record(model, id)
    model.find(id)
  rescue ActiveRecord::RecordNotFound
    { error: 'Record not found' }
  end

  def self.update_record(model, id, params)
    record = model.find(id)

    if record.update(params)
      { message: 'Record updated successfully', record: record }
    else
      { error: 'Failed to update record', errors: record.errors }
    end
  rescue ActiveRecord::RecordNotFound
    { error: 'Record not found' }
  end

  def self.delete_record(model, id)
    record = model.find(id)

    if record.destroy
      { message: 'Record deleted successfully' }
    else
      { error: 'Failed to delete record' }
    end
  rescue ActiveRecord::RecordNotFound
    { error: 'Record not found' }
  end

  def self.sort_records(model, attribute, order = 'asc')
    model.order(attribute => order)
  end

  def self.paginate_records(model, page, per_page)
    page = page.to_i.positive? ? page.to_i : 1
    model.paginate(page: page, per_page: per_page)
  end

  def self.search_records(model, attribute_names, search, model_name = nil)
    model_name ||= model.name
    conditions = []

    attribute_names.each do |attribute_name|
      conditions << "#{model_name.downcase.pluralize}.#{attribute_name} LIKE '%#{search}%'" if search.present?
    end

    if conditions.present?
      model.where(conditions.join(' OR '))
    else
      model.all
    end
  end
end
