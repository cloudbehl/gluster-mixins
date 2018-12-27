local kp = (import 'kube-prometheus.libsonnet') + {
  _config+:: {
    namespace: 'monitoring',
  },
};

{ ['00namespace-' + name]: kp.kubePrometheus[name] for name in std.objectFields(kp.kubePrometheus) } +
{ ['prometheus-' + name]: kp.prometheus[name] for name in std.objectFields(kp.prometheus) }
