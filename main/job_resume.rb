
# encoding: utf-8

require 'active_record'

class JobResume	< ActiveRecord::Base
  self.table_name = "job_resume"
  self.primary_key = "r_id"

  include ActiveModel::Validations
  belongs_to :job_member,:foreign_key=>"r_mid",:class_name=>'JobMember'

end