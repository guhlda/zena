require File.dirname(__FILE__) + '/../test_helper'
require 'application'

# Re-raise errors caught by the controller.
class ApplicationController; def rescue_action(e) raise e end; end

class ApplicationControllerTest < ZenaTestController
  
  def setup
    super
    @controller = ApplicationController.new
    init_controller
    login(:anon)
    @controller.send(:params=, {})
  end
  
  def test_acts_as_secure
    assert_nothing_raised { node = @controller.send(:secure,Node) { Node.find(ZENA_ENV[:root_id])}}
  end
  
  # render_and_cache and authorize tested in MainControllerTest
  
  # visitor tested in multiple_hosts integration test
  
  def test_find_template_document
    res = @controller.instance_variable_set(:@skin_name, 'wiki')
    assert false, "finish test"
  end

  def test_template_url_any_project
    without_files('app/views/templates/compiled') do
      wiki = @controller.send(:secure,Node) { Node.find(nodes_id(:wiki)) }
      assert_equal 'wiki', wiki.skin
      @controller.instance_variable_set(:@node, wiki)
      assert !File.exist?(File.join(RAILS_ROOT, 'app/views/templates/compiled/wiki/any_project_en.rhtml')), "File does not exist"
      assert_equal '/templates/compiled/wiki/any_project_en', @controller.send(:template_url)
      assert File.exist?(File.join(RAILS_ROOT, 'app/views/templates/compiled/wiki/any_project_en.rhtml')), "File exist"
    end
  end
  
  def test_template_url_any
    without_files('app/views/templates/compiled') do
      bird = @controller.send(:secure,Node) { Node.find(nodes_id(:bird_jpg)) }
      assert_equal 'wiki', bird.skin
      @controller.instance_variable_set(:@node, bird)
      assert !File.exist?(File.join(RAILS_ROOT, 'app/views/templates/compiled/wiki/any_en.rhtml')), "File does not exist"
      assert_equal '/templates/compiled/wiki/any_en', @controller.send(:template_url)
      assert File.exist?(File.join(RAILS_ROOT, 'app/views/templates/compiled/wiki/any_en.rhtml')), "File exist"
    end
  end

  def test_template_url_index
    bird = @controller.send(:secure,Node) { Node.find(nodes_id(:bird_jpg)) }
    assert_equal 'wiki', bird.skin
    @controller.instance_variable_set(:@node, bird)
    assert_equal '/templates/fixed/default/any__index', @controller.send(:template_url, :mode=>'index')
  end
  
  def test_class_skin
    proj = @controller.send(:secure,Node) { Node.find(nodes_id(:cleanWater)) }
    assert_equal 'default', proj.skin
    @controller.instance_variable_set(:@node, proj)
    assert_equal '/templates/fixed/default/any_project', @controller.send(:template_url)
    proj.skin = 'truc'
    assert_equal 'truc', proj.skin
    assert_equal '/templates/fixed/default/any_project', @controller.send(:template_url)
    assert_equal '/templates/fixed/default/any__index', @controller.send(:template_url, :mode=>'index')
  end
  
  def test_general_class_skin
    letter = @controller.send(:secure, Node) { Node.find(nodes_id(:letter)) }
    assert_equal 'default', letter.skin
    @controller.instance_variable_set(:@node, letter)
    assert_equal '/templates/fixed/default/any_letter', @controller.send(:template_url)
  end
  
  
  def test_parse_date
    visitor.instance_eval { @tz = TimeZone.new("Azores") } # UTC - 1h
    assert_equal Time.gm(2006,11,10,1), visitor.tz.unadjust(Time.gm(2006,11,10))
    assert_equal Time.gm(2006,11,10,1), @controller.send(:parse_date, '2006-11-10', '%Y-%m-%d')
    assert_equal Time.gm(2006,11,10,1), @controller.send(:parse_date, '10.11 2006', '%d.%m %Y')
    assert_equal Time.gm(2006,11,10,1), @controller.send(:parse_date, '10.11 / 06', '%d.%m.%y')
    assert_equal Time.gm(Time.now.year,11,10,1), @controller.send(:parse_date, '11-10', '%m.%d')
  end
  
  def test_parse_date_time
    visitor.instance_eval { @tz = TimeZone.new("Azores") } # UTC - 1h
    assert_equal Time.gm(2006,11,10,13,30), @controller.send(:parse_date, '2006-11-10 12:30', '%Y-%m-%d %H:%M')
    visitor.instance_eval { @tz = TimeZone.new("Bern") } # UTC + 1h
    assert_equal Time.gm(2006,11,10,11,30), @controller.send(:parse_date, '2006-11-10 12:30', '%Y-%m-%d %H:%M')
    assert_equal Time.gm(2006,11,10,11,30), @controller.send(:parse_date, '2006-11-10 12:30')
    visitor.instance_eval { @tz = TimeZone.new("London") } # UTC
    assert_equal Time.gm(2006,11,10,12,30), @controller.send(:parse_date, '10.11.2006 12:30', '%d.%m.%Y %H:%M')
  end
  
  # check_is_admin, admin_layout tested in user_controller_test
  
  # // test methods common to controllers and views // #
  
  def test_lang
    assert_equal ZENA_ENV[:default_lang], @controller.send(:lang)
    @controller.instance_variable_set(:@session, :lang=>'io')
    assert_equal 'io', @controller.send(:lang)
  end
  
  # trans tested in ApplicationHelperTest
  def test_trans
    assert_equal 'yoba', @controller.send(:trans,'yoba')
    @controller.instance_variable_set(:@session, :lang=>'fr')
    assert_equal 'lundi', @controller.send(:trans,'Monday')
    @controller.instance_variable_set(:@session, :lang=>'en', :translate=>true)
    assert_equal 'yoba', @controller.send(:trans,'yoba')
  end
  
  def test_prefix
    bak = ZENA_ENV[:monolingual]
    ZENA_ENV[:monolingual] = false
    @controller.instance_variable_set(:@session, :lang=>'en')
    assert_equal 'en', @controller.send(:prefix)
    @controller.instance_variable_set(:@session, :lang=>'ru')
    assert_equal 'ru', @controller.send(:prefix)
    @controller.instance_variable_set(:@session, :user=>{:id=>4, :lang=>'en', :groups=>[1,2,3]})
    assert_equal AUTHENTICATED_PREFIX, @controller.send(:prefix)
    ZENA_ENV[:monolingual] = true
    @controller.instance_variable_set(:@session, :user=>nil)
    assert_equal '', @controller.send(:prefix)
    @controller.instance_variable_set(:@session, :user=>{:id=>4, :lang=>'en', :groups=>[1,2,3]})
    assert_equal AUTHENTICATED_PREFIX, @controller.send(:prefix)
    ZENA_ENV[:monolingual] = bak
  end
  
  def test_bad_session_user
    @controller.instance_variable_set(:@session, :user=>999, :host=>'test.host')
    assert_equal users_id(:anon), @controller.send(:visitor)[:id]
  end
  
  # authorize tested in 'MainController' tests
  
end
