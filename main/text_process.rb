# encoding: utf-8
class TextProcess
  require "./craw_user"
  require "csv"
  #初始化方法
  def initialize(text,login)
    @user_attrs = [login]
    text = text.gsub(/\s| |　|　/,'')

    edrc_regular1 = /\(http:\/\/www.edrc.cn\)(.+?)的个人简历.*年龄：(\d*?)性别：(.*?)政治面貌：(.*?)民族：(.*?)学历：(.*?)婚姻状况：(.*?)・求职意向.*?・工作情况所学专业：(.*?)工作经验：(.*?)在职单位：(.*?)在职职位：(.*?)工作经历：(.*?)・其他说明教育情况：/
    edrc_regular2 = /・求职意向要求月薪：(.*?)工作性质：(.*?)求职意向：(.*?)具体职务：(.*?)・工作情况所学专业.*?教育情况：(.*?)语言水平：(.*?)技术专长：(.*?)联系我时，请说是在南阳E动人才网上看到的/
    edrc_regular3 = /・联系方式家庭住址：(.*?)联系电话：(.*?)电子邮箱：(.*?)手机或OICQ：(.*?)联系我时，/

    match_text1 = edrc_regular1.match(text) rescue MatchData.new
    match_text2 = edrc_regular2.match(text) rescue MatchData.new
    match_text3 = edrc_regular3.match(text) rescue MatchData.new

    12.times do |i|
      i+=1
      @user_attrs << match_text1[i] rescue ""
    end
    8.times do |i|
      i+=1
      @user_attrs << match_text2[i] rescue ""
    end
    4.times do |i|
      i+=1
      @user_attrs << match_text3[i] rescue ""
    end
  end

  attr_accessor :user_attrs

  #保存到数据库
  def save_to_sql
    @craw_user = CrawUser.build_by_user_attrs(@user_attrs)
    @craw_user.save
  end

  ##保存到csv文件
  def save_to_csv(file_path = "../data/users.csv")
    CSV.open(file_path,"a+") do |csv|
      csv << @user_attrs.map{|u|u.encode("gb2312") if u.present?}
    end
  end

end
