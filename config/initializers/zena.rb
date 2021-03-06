# This has to come first
Zena::Fix::MysqlConnection

# All models can use attr_public
ActiveRecord::Base.send :include, Zena::Use::PublicAttributes
ActiveRecord::Base.send :include, Zena::Use::Zafu::ModelMethods
ActiveRecord::Base.send :include, Zena::Use::NodeQueryFinders::AddUseNodeQueryMethod
ActiveRecord::Base.send :include, Zena::Use::Relations::AddUseRelationsMethod
ActiveRecord::Base.send :include, Zena::Use::FindHelpers
ActiveRecord::Base.send :include, Zena::Acts::Secure
ActiveRecord::Base.send :include, Zena::Acts::Multiversion::AddActsAsMethods

ActiveRecord::Base.send :use_find_helpers # find helpers for all models

Bricks::Patcher.load_bricks
