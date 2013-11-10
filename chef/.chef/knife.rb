cookbook_path ["cookbooks", "site-cookbooks"]
node_path     "nodes"
role_path     "roles"
data_bag_path "data_bags"

maintainer       "foostan"
maintainer_email "dev@fstn.jp"

cookbook_copyright "foostan"
cookbook_email     "dev@fstn.jp"
cookbook_license   "mit"

knife[:berkshelf_path] = "cookbooks"
