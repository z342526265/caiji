# encoding: utf-8

require 'mechanize'
require 'active_record'
require 'active_support/all'
require "csv"

require "./config"
require './text_process'
require './create_table'

#连接数据库
ActiveRecord::Base.establish_connection(DATABASE_CONFIG)
CrawUser.where("created_at < ?",Time.now - 1.weeks)
#puts "删除一周前暂存的数据......"
# 创建数据暂存的表 craw_users ，用于保存抓取到的数据
# begin
  # CreateTable.new.change
  # puts "表craw_users创建成功"
# rescue
  # puts "表已存在"
# end

#创建agent对象
a = Mechanize.new { |agent|
  agent.user_agent_alias = 'Windows Mozilla'
}

#循环抓取数据
# while true

  begin

    link_arr = []
    #获取链接地址
    (1..1).each do |p|
      try_num1 = 1
      begin
        page = a.get("http://www.edrc.cn/nyrenli.asp?page=1")
      rescue Mechanize::ResponseCodeError
        try_num1 = try_num1 + 1
        retry if try_num1 < 10
      end

      page.links.each do |l|
        if l.href.to_s.match(/pname=/)
          link_arr << [l.href,l.text]
        end
      end
    end

    #遍历抓取，保存到数据库 ,并把不重复的保存进数组 attr_arr
    link_arr.each do |link,name|
      login = link.match(/.*pname=(.*)/)[1]

      begin
        new_url = "http://www.edrc.cn/"+link
        new_url = URI.escape(new_url.encode("gb2312"))
        new_page = a.get(new_url)

        if new_page.form("form1")
          new_page.form("form1").field("user").value = "则铭"
          new_page.form("form1").field("pwd").value = "guangyi888"
          new_page.form.submit
          new_page = a.get(new_url)
        end
      end

      next if new_page.blank?
      html_text = new_page.search("td").text
      @text_process = TextProcess.new(html_text,login)

      #保存到数据库
      if @text_process.save_to_sql
        @text_process.save_to_csv
      end
    end

    puts Time.now.to_s + "抓取一遍"
    # sleep INTERVAL_TIME+rand(INTERVAL_TIME)


  rescue
    "异常"
  end

# end



