#coding: utf-8
require "open-uri"
require "nokogiri"
require "kconv"
class Master::OfficialCompany < ActiveRecord::Base

  class << self
    #公式サイトとマスタを同期する
    def sync
      ("A".."N").each do |suffix|
        begin
          page = open("http://privacymark.jp/certification_info/list/gyousyu/list_#{suffix}.html").read.toutf8
        rescue Execption
          next
        end

        doc = Nokogiri::HTML(page, nil)
        trs = doc.xpath("//tr")

        trs.each do |tr|
          td = tr.xpath(".//td")
          if td.size == 7
            master = ::Master::OfficialCompany.find_or_initialize_by_code(td[0].text)

            master.name = td[1].text
            master.address = td[2].text
            master.category = td[3].text
            master.expiration_date = Date.parse("H#{td[4].text}")
            master.agency = td[5].text
            master.jis_code = td[6].text

            master.save
          end
        end
      end
    end


  end
end
