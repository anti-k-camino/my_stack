class PermissionValidator < ActiveModel::Validator
  def validate(obj)
    obj.errors[:user] << "Permission denied for author of resource" if obj.user == obj.votable.user    
  end
end