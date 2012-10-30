# encoding: utf-8

require 'active_record'

class CrawUser	< ActiveRecord::Base
  include ActiveModel::Validations

  validates_uniqueness_of :u_22,:u_0

  def self.build_by_user_attrs(user_attrs=Array.new)
    attr_hash = {}
    25.times do |i|
      attr_hash["u_#{i}"] = user_attrs[i]
    end
    return CrawUser.new(attr_hash)
  end



#从数据库中取出数据，转化为人才网数据库对应的字段
  def trans_to_member
    sex_int = rand(2)+1
    case self.u_3
      when "男"
        sex_int = 1
      when "女"
        sex_int = 2
    end

    #case self.u_6
    #  when "高中及以下"
    #    edu_num = 2
    #  when "中专"
    #    edu_num = 4
    #  when "大专"
    #    edu_num = 5
    #  when "本科"
    #    edu_num = 6
    #  when "硕士"
    #    edu_num = 7
    #  when "博士"
    #    edu_num = 8
    #  else
    #    edu_num = 0
    #end

    m_polity = self.u_4.gsub(/中国共青|中国共产/,"") rescue "群众"

    attrs = {
        "m_login"=>self.u_0,
        "m_pwd"=>"e10adc3949ba59abbe56e057f20f883e",
        "m_sendemail"=>1,
        "m_question"=>"我就读的第一所学校是？",
        "m_answer"=>"d41d8cd98f00b204e9800998ecf8427e",
        "m_typeid" => 1,
        "m_groupid" => 2,
        "m_email" => self.u_23,
        "m_emailshowflag" => 1,
        "m_name" => self.u_1,
        "m_sex" => sex_int,
        "m_birth" => Date.today - self.u_2.to_i.years,
        "m_groupid" => 3,
        "m_cardtype" => 0,
        "m_idcard" => "",
        "m_marriage" => self.u_7,
        "m_polity" => m_polity,
        "m_hukou" => "**",
        "m_seat" => "**",
        "m_edu" => edu_to_int(self.u_6),
        "m_address" => self.u_21,
        "m_post" => "",
        "m_contact" => self.u_1,
        "m_chat" => "",
        "m_tel" => self.u_22,
        "m_telshowflag" => 1,
        "m_fax" => "",
        "m_url" => "",
        "m_regdate" => Time.now,
        "m_logindate" => Time.now,
        "m_loginip" => "",
        "m_loginnum" => 1,
        "m_level" => "",
        "m_balance" => 0,
        "m_integral" => 0,
        "m_flag" => 1,
        "m_startdate" => Date.today,
        "m_enddate" => "2033-03-03",
        "m_resumenums" => 1,
        "m_myinterviewnums" => 0,
        "m_myfavoritenums" => 3,
        "m_letternums" => 1,
        "m_hirenums" => 0,
        "m_interviewnums" => 0,
        "m_expertnums" => 0,
        "m_logoflag" => 1,
        "m_logostatus" => 1,
        "m_mobile" => self.u_24,
        "m_contactnum" => 3,
        "m_mysendnums" => 3,
        "m_nameshow" => 1,
        "m_activedate" => Date.today,
        "m_commend" => "2000-01-01",
        "m_commstart" => "2000-01-01",
        "m_ecoclass" => "",
        "m_founddate" => "2000-01-01",
        "m_licence" => "",
        "m_logo" => "",
        "m_logoenddate" => "2000-01-01",
        "m_logostartdate" => "2000-01-01",
        "m_map" => "",
        "m_openid" => 0,
        "m_operator" => "",
        "m_qzstate" => 0,
        "m_template" => "",
        "m_trade" => "",
        "m_workers" => ""
    }
    return attrs
  end



#从数据库中取出数据，转化为人才网数据库对应的字段
  def trans_to_resume

    case self.u_14
      when "全职"
        job_type = 1
      when "兼职"
        job_type = 2
      else
        job_type = 3
    end

    r_attrs = {}

    r_attrs[:r_member] = self.u_0
    r_attrs[:r_title] = "我的求职简历"
    r_attrs[:r_chinese] = 1
    r_attrs[:r_cnstatus] = 1
    r_attrs[:r_name] = self.u_1
    r_attrs[:r_nation] = self.u_5
    r_attrs[:r_polity] = self.u_4.gsub(/中国共青|中国共产/,"")
    r_attrs[:r_marriage] = self.u_7
    r_attrs[:r_hukou] = "**"
    r_attrs[:r_seat] = "**"
    r_attrs[:r_mobile] = self.u_24
    r_attrs[:r_email] = self.u_23
    r_attrs[:r_address] = self.u_21
    r_attrs[:r_chat] = ""
    r_attrs[:r_idcard] = ""
    r_attrs[:r_graduate] = "2000-01-01"
    r_attrs[:r_sumup] = ""     #特点概况
    r_attrs[:r_appraise] = self.u_19       #自我评价
    r_attrs[:r_jobtype] = job_type
    r_attrs[:r_trade] = ""   #意向行业
    r_attrs[:r_position] = self.u_15   #意向岗位类别
    r_attrs[:r_workadd] = "河南省南阳市"    #意向工作地区
    r_attrs[:r_edu] = edu_to_int(self.u_6)
    r_request = case self.u_13.to_s[0,5].to_i
      when (0..800)
        1
      when (800..1000)
        2
      when (1000..1200)
        3
      when (1200..1500)
        4
      when (1500..2000)
        5
      when (2000..2500)
        6
      when (2500..3000)
        7
      when (3000..4000)
        8
      when (4000..6000)
        9
      when (6000..9000)
        10
      when (9000..12000)
        11
      when (12000..15000)
        12
      when (15000..20000)
        13
      when (20000..50000)
        14
      else
        0
    end

    r_attrs[:r_request] = self.u_11
    r_attrs[:r_pay] = r_request
    r_attrs[:r_personinfo] = 1
    r_attrs[:r_careerwill] = 1
    r_attrs[:r_visitnum] = 1
    r_attrs[:r_adddate] = Time.now
    r_attrs[:r_flag] = 1
    r_attrs[:r_ability] = self.u_12
    r_attrs[:r_post] = ""
    r_attrs[:r_school] = ""
    r_attrs[:r_tel] = self.u_22
    r_attrs[:r_template] = ""
    r_attrs[:r_url] = ""
    r_attrs[:r_zhicheng] = ""
    r_attrs[:r_birth] =  Date.today - self.u_2.to_i.years

    return r_attrs
  end

  private
  def edu_to_int(txt)
    case txt
      when "高中及以下"
        edu_num = 2
      when "中专"
        edu_num = 4
      when "大专"
        edu_num = 5
      when "本科"
        edu_num = 6
      when "硕士"
        edu_num = 7
      when "博士"
        edu_num = 8
      else
        edu_num = 0
    end
    return edu_num
  end

end