 # encoding: utf-8

require 'active_record'

class JobMember	< ActiveRecord::Base

  include ActiveModel::Validations

  self.table_name = "job_member"
  self.primary_key = "m_id"
  has_many :job_resumes,:foreign_key=>"r_mid",:class_name=>'JobResume',:dependent => :destroy
  has_many :job_hires,:foreign_key=>"h_comid",:class_name=>'JobHire',:dependent => :destroy

end