The ActiveCrud gem is a utility library for performing common data operations in Rails applications. It provides convenient methods for creating records, retrieving records, updating records, deleting records, sorting records, paginating records, and searching records.

## Features

- CRUD operations: Create, retrieve, update, and delete records.
- Sorting: Sort records based on column names and directions.
- Pagination: Display a limited number of records per page.
- Searching: Search records based on specific parameters.

## Installation

Add the ActiveCrud gem to your Gemfile:

```ruby
gem 'active_crud' 
```
### Dependencies
For Pagination Use Gem 'will_paginate'
```ruby
gem 'will_paginate' 
```

Then, run the following command to install the gem:

```ruby
bundle install
```
# Features
### Creating a Record
To create a record, use the ActiveCrud.create_record method:
```ruby
record_params = { attribute1: value1, attribute2: value2, ... }
result = ActiveCrud.create_record(ModelClass, record_params)
```
The create_record method returns a result hash containing the following keys:
:message if the record is created successfully, along with the created record.
:error if the record fails to create, along with the validation errors.

### Retrieving All Records
To retrieve all records of a model, use the ActiveCrud.retrieve_all_records method:
```ruby
records = ActiveCrud.retrieve_all_records(ModelClass)
```
This method returns a collection of all records for the specified model.

### Retrieving a Specific Record
To retrieve a specific record by its ID, use the ActiveCrud.retrieve_record method:
```ruby
result = ActiveCrud.retrieve_record(ModelClass, id)
```
The retrieve_record method returns the found record if it exists, or an error message if the record was not found.

### Updating a Record
To update a record with new parameters, use the ActiveCrud.update_record method:
```ruby
record_params = { attribute1: new_value1, attribute2: new_value2, ... }
result = ActiveCrud.update_record(ModelClass, id, record_params)
```
The update_record method returns a result hash containing the following keys:
:message if the record is updated successfully, along with the updated record.
:error if the record fails to update, along with the validation errors.
### Deleting a Record
To delete a record by its ID, use the ActiveCrud.delete_record method:
```ruby
result = ActiveCrud.delete_record(ModelClass, id)
```
The delete_record method returns a result hash containing the following keys:
:message if the record is deleted successfully.
:error if the record fails to delete.
### Sorting Records
To sort records based on a column name and direction, use the ActiveCrud.sort_records method:
```ruby
sorted_records = ActiveCrud.sort_records(ModelClass, column, direction)
```
The sort_records method returns a collection of records sorted based on the specified column name and direction.

### Paginating Records
To paginate records and display a limited number of results per page, use the ActiveCrud.paginate_records method:
```ruby
paginated_records = ActiveCrud.paginate_records(ModelClass, page, per_page)
```
The paginate_records method returns a collection of records for the specified page number and number of records per page.

### Searching Records
To search records based on specific parameters, use the ActiveCrud.search_records method:
```ruby
search_params = { attribute1: value1, attribute2: value2, ... }
searched_records
```

# Working Example with real Rails Application
#### Gemfile
gem 'active_crud'

#### app/models/user.rb
```ruby
class User < ApplicationRecord
  validates :first_name, :last_name, :email, :password, presence: true
  validates :email, uniqueness: true
end
```
#### app/controllers/users_controller.rb
```ruby
class UsersController < ApplicationController
  def index
    @users = ActiveCrud.retrieve_all_records(User)
    if params[:search].present?
      @users = ActiveCrud.search_records(@users, %w[first_name last_name],
                                         sanitize_params(params[:search]))
    end
    if params[:sort].present?
      @users = ActiveCrud.sort_records(@users, sanitize_params(params[:sort]),
                                       sanitize_params(params[:direction]))
    end
    @users = ActiveCrud.paginate_records(@users, sanitize_params(params[:page]), 10)
  end

  def new
    @user = User.new
  end

  def create
    result = ActiveCrud.create_record(User, user_params)

    if result[:record]
      redirect_to result[:record], notice: result[:message]
    else
      @user = User.new(user_params)
      flash.now[:error] = result[:error]
      render :new
    end
  end

  def show
    @user = ActiveCrud.retrieve_record(User, params[:id])
    redirect_to users_path, alert: @user[:error] if @user[:error]
  end

  def edit
    @user = ActiveCrud.retrieve_record(User, params[:id])
    redirect_to users_path, alert: @user[:error] if @user[:error]
  end

  def update
    result = ActiveCrud.update_record(User, params[:id], user_params)

    if result[:record]
      redirect_to result[:record], notice: result[:message]
    else
      @user = ActiveCrud.retrieve_record(User, params[:id])
      flash.now[:error] = result[:error]
      render :edit
    end
  end

  def destroy
    result = ActiveCrud.delete_record(User, params[:id])

    redirect_to users_path, notice: result[:message] if result[:message]
    redirect_to users_path, alert: result[:error] if result[:error]
  end

  private

  def sanitize_params(value)
    value.present? ? Arel.sql(value) : nil
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end
end
```

#### app/views/users/index.html.erb
```ruby
<h1>Users</h1>
<%= form_tag users_path, method: :get do %>
  <%= text_field_tag :search, params[:search] %>
  <%= submit_tag "Search" %>
<% end %>

<table>
  <thead>
    <tr>
      <%= link_to 'First Name', { sort: 'first_name', direction: sort_direction('first_name') } %>
      <%= link_to 'Last Name', { sort: 'last_name', direction: sort_direction('last_name') } %>
      <%= link_to 'Email', { sort: 'email', direction: sort_direction('email') } %>
      <th>Actions</th>
    </tr>
  </thead>

  <tbody>
    <% @users.each do |user| %>
      <tr>
        <td><%= user.first_name %></td>
        <td><%= user.last_name %></td>
        <td><%= user.email %></td>
        <td>
          <%= link_to 'Show', user_path(user) %>
          <%= link_to 'Edit', edit_user_path(user) %>
          <%= link_to "Delete", user_path(user), method: :delete, data: { turbo_method: :delete, turbo_confirm: 'Are you sure?' }, class: 'btn btn-danger' %>

        </td>
      </tr>
    <% end %>
  </tbody>
</table>
<%= will_paginate %>

<p>
  <%= link_to 'New User', new_user_path %>
</p>
```
#### app/helpers/application_helper.rb
```ruby
def sort_direction(column)
    column == params[:sort] && params[:direction] == 'asc' ? 'desc' : 'asc'
end
```
