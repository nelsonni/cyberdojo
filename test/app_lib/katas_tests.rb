require File.dirname(__FILE__) + '/../test_helper'
require 'ExposedLinux/Paas'

class KatasTests < ActionController::TestCase

  test "dojo.katas.each forwards to katas_each on paas" do
    paas = ExposedLinux::Paas.new
    dojo = paas.create_dojo(root_path,'rb')
    katas = dojo.katas.map {|kata| kata.id}
    assert katas.size > 100
    assert katas.all?{|id| id.length == 10}
  end

  test "dojo.katas[id]" do
    paas = ExposedLinux::Paas.new
    dojo = paas.create_dojo(root_path,'rb')
    kata = dojo.katas["ABCDE12345"]
    assert_equal ExposedLinux::Kata, kata.class
    assert_equal "ABCDE12345", kata.id
  end

  test "dojo.katas[id].start_avatar" do
    paas = ExposedLinux::Paas.new
    dojo = paas.create_dojo(root_path,'rb')
    kata = dojo.katas["ABCDE12345"]
    avatar = kata.start_avatar
    assert_equal ExposedLinux::Avatar, avatar.class
    assert_equal 'lion', avatar.name
  end

end