class CreateUserForm < Chassis::Form
  attribute :name, String
  attribute :auth_token, String
  attribute :device, Hash
end
