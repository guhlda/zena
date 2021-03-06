ActionController::Routing::Routes.add_route '----/test/:action', :controller => 'zena/test'

module Zena
  class TestController < ApplicationController
    helper_method :get_template_text, :template_url_for_asset, :save_erb_to_url
    before_filter :set_context
    ZazenParser = Parser.parser_with_rules(Zazen::Rules, Zazen::Tags)
    ZafuParser  = Parser.parser_with_rules(Zafu::Rules, Zena::Rules, Zafu::Tags, Zena::Tags)
    class << self
      def templates=(templates)
        @@templates = templates
      end
    end
    def test_compile
      render :text => ZafuParser.new_with_url(@test_url, :helper => zafu_helper).render(:dev => params['dev'])
    end

    def test_render
      render :inline => @text
    end

    def test_zazen
      render :text => ZazenParser.new(@text, :helper => zafu_helper).render
    end

    private
    # by pass application before actions
    def authorize
    end
  
    def set_lang
    end

    def set_context
      @visitor = User.make_visitor(:id => params[:user_id], :host => request.host)
      set_visitor_lang(params[:prefix])
      @node = secure!(Node) { Node.find(params[:node_id])}
      @text = params[:text]
      @test_url  = params[:url]
      @date = Date.parse(params[:date]) if params[:date]
      params.delete(:user_id)
      params.delete(:prefix)
      params.delete(:node_id)
      params.delete(:text)
      params.delete(:url)
    end

    def get_template_text(opts={})
      src    = opts[:src]
      folder = (opts[:current_folder] && opts[:current_folder] != '') ? opts[:current_folder][1..-1].split('/') : []
      src = src[1..-1] if src[0..0] == '/' # just ignore the 'relative' or 'absolute' tricks.
      url = (folder + src.split('/')).join('_')
    
      if test = @@templates[url]
        [test['src'], src]
      else
        # 'normal' include
        @expire_with_nodes = {}
        @skin_names = ['default']
        super
      end
    end
  
  end
end