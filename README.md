# kubeadm-ha_ansible

# 主机清单

本文中出现的 ip 请根据实际情况修改。

| 主机名 | ip地址 | 说明 | 组件 |
| --- | --- | --- | --- |
| master-vip.local | 30.99.142.161 | keepalived 浮动ip | 无 |
| master-01.local | 30.99.142.166 | control-plane | keepalived、nginx、kubelet、kube-apiserver、kube-scheduler、kube-controller-manager、etcd |
| master-02.local | 30.99.142.164 | control-plane | keepalived、nginx、kubelet、kube-apiserver、kube-scheduler、kube-controller-manager、etcd |
| master-03.local | 30.99.142.162 | control-plane | keepalived、nginx、kubelet、kube-apiserver、kube-scheduler、kube-controller-manager、etcd |
| sysnode-01.local | 30.99.142.165 | sysnode-01 | kubelet |
| sysnode-02.local | 30.99.142.163 | sysnode-02 | kubelet |

# 操作步骤

## 准备步骤

- 在 master-01 上配置基于 `ssh` 证书的认证

```
# on master-01
ssh-keygen -t rsa
ssh-copy-id -i ~/.ssh/id_rsa.pub root@30.99.142.164
ssh-copy-id -i ~/.ssh/id_rsa.pub root@30.99.142.162
ssh-copy-id -i ~/.ssh/id_rsa.pub root@30.99.142.165
ssh-copy-id -i ~/.ssh/id_rsa.pub root@30.99.142.163
```

- 验证 `ansible` 可以以 `root` 身份访问目标主机

```
cd /root && mkdir -pv ansible_playbook && cd ansible_playbook
# 把 ansible_hosts.txt 放在 ansible_playbook 目录下
ansible -i ansible_hosts.txt all -m ping
```

- 升级内核到 5.0 以上(可选)

Kubernetes v1.14 开始，修复了preflight check 时检测到 Linux OS kernel 高于 5.0 时会失败的问题。
在 kernel 5.0 以上的系统中使用 kubeadm v1.13 及以下版本时，可以使用 `--ignore-preflight-errors=....` 标记来解决此问题。
kernel 5.0 支持一些新功能和驱动，升级方法如下:

```
ansible-playbook -i production/ansible_hosts.txt update_kernel.yml
```

## 修改集群相关信息以及执行安装用 playbook

### 设置防火墙和 SELinux

```
ansible-playbook -i production/ansible_hosts.txt setting_firewall_and_selinux.yml
```

### 设置 keepalived 和 nginx-lb 来实现 vip 和负载均衡

```
ansible-playbook -i production/ansible_hosts.txt setting_keepalived_and_nginx-lb.yml
```



