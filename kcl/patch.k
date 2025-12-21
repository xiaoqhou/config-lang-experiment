import yaml
import file

_component = option("component")
_feature_flags = yaml.decode(file.read("feature-flag.yaml"))

_helmfile = yaml.decode(file.read("helmfile.yaml")) 

_comp_feat_flag = _feature_flags[_component]

if _comp_feat_flag is not Undefined:
  if not _comp_feat_flag.enabled:
    _helmfile.releases = [ (v | {installed = "false"}) for v in _helmfile.releases ]
  else:
    _sub_components = [ v for v in _comp_feat_flag if v != "enabled" ]
    _helmfile.releases = [ v if _comp_feat_flag[v.name] is Undefined or _comp_feat_flag[v.name].enabled else v | {installed = "false"} for v in _helmfile.releases ]


_helmfile

