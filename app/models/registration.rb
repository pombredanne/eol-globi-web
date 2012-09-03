class Registration < ActiveRecord::Base
  
  attr_accessible :email, :institution, :name

  validates :institution,    :presence    => true
  
  validates :name,    :presence    => true
  
  validates :email,    :presence    => true,
                       :length      => {:minimum => 5, :maximum => 254},
                       :uniqueness  => true,
                       :format      => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}
  
end
