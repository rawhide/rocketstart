require 'spec_helper'

require './lib/railstar/helper'

require 'erb'
include Railstar::Helper
include ERB::Util


describe Railstar::Helper do
  it '改行コードをBRタグに変換できること' do
    text = <<-EOF
abcd
efghi
jklm
EOF
    hbr(text).should == "abcd<br />efghi<br />jklm<br />"
  end
end
