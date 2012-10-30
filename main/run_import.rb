# encoding: utf-8
require 'active_record'
require 'active_support/all'
require "logger"

require "./config"
require "./craw_user"
require "./job_member"
require "./job_resume"

# while true
#连接数据库
ActiveRecord::Base.establish_connection(DATABASE_CONFIG)
# ActiveRecord::Base.logger = Logger.new(File.open('../data/database.log', 'a'))
puts Time.now
# 5.times do
if ActiveRecord::Base.connection.active?
  begin
    #从数据库中找一个未经过导入的数据
    user = CrawUser.find_by_u_30(false)
    #如果数据库中有未导入的用户
    if user.present?
      @member1 = JobMember.where("m_tel = ? or m_mobile = ?",user.u_22,user.u_22).first
      #如果根据电话找到了用户,更新用户的简历
      if @member1.present? && @member1.job_resumes.present?
        @member1.job_resumes.first.update_attributes("r_adddate"=>Time.now)
        puts user.u_1.to_s + "  已经更新！ #{Time.now} 等待下一个......"
      end

      #如果根据电话找不到用户，而且抓取的用户的邮箱存在，则试着根据邮箱找用户，如果找到，更新用户的姓名，电话，简历
      if @member1.blank? && user.u_23 != "暂没提供"
        @member2 = JobMember.find_by_m_email(user.u_23)
        if @member2.present?
          @member2.m_tel = user.u_22
          @member2.m_name = user.u_1
          @member2.save
          @member2.job_resumes.first.update_attributes("r_adddate"=>Time.now)
          puts user.u_1.to_s + "  已经更新！ #{Time.now} 等待下一个......"
        end
      end

      #如果根据电话，邮箱都找不到用户,则添加一个用户，一个用户简历
      if @member1.blank? && @member2.blank?
        ActiveRecord::Base.transaction do
          m_attrs = user.trans_to_member
          @member = JobMember.new(m_attrs)
          if @member.save
            ActiveRecord::Base.connection.execute("update job_member set m_sex = #{m_attrs["m_sex"]} where m_id=#{@member.m_id}")
            @resume = @member.job_resumes.build(user.trans_to_resume)
            if @resume.save
              ActiveRecord::Base.connection.execute("update job_resume set r_sex = #{m_attrs["m_sex"]} where r_id=#{@resume.r_id}")
            end
            puts user.u_1.to_s + "  已经新增！ #{Time.now} 等待下一个......"
          end
        end
      end
      user.update_attributes(:u_30=>true)
    end
      # sleep (IMPORT_TIME_LOW + rand(IMPORT_TIME_TOP-IMPORT_TIME_LOW+1)).minutes
  rescue
    if user.present?
      puts "异常"
      user.update_attributes(:u_30=>true) if ActiveRecord::Base.connection.active?
    else
      puts "等待抓取新数据......"
      # sleep INTERVAL_TIME
    end
  end
end
# end
# end

