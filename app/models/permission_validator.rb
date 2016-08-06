class PermissionValidator < ActiveModel::Validator
  def validate(obj)
    if obj.user == obj.votable.user 
      obj.errors[:user] << "Permission denied for author of resource" 
    end   
  end
end