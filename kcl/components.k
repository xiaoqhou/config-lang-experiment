import yaml
import file

_component = option("component")
_feature_flags = yaml.decode(file.read("components.yaml"))

_helmfile = yaml.decode(file.read("helmfile.yaml").replace("{{","#{{")) 

_comp_feat_flag = _feature_flags[_component]

if _comp_feat_flag is not Undefined:
  if not _comp_feat_flag.enabled:
    _helmfile.releases = [ (v | {installed = False}) for v in _helmfile.releases ]
  else:
    _sub_components = { k:v for k,v in _comp_feat_flag if k != "enabled" }
    _helmfile.releases = [ v if _sub_components[v.name] is Undefined or _sub_components[v.name].enabled else (v | {installed = False}) for v in _helmfile.releases ]

_helmfile

