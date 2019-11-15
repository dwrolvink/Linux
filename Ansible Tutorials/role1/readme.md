For your first ansible directory, find a nice spot where you want to create it, and then make a roles directory:
```bash
mkdir roles
cd roles
```
Then, we can create our first empty role. Ansible-galaxy is nice for this because it will create all the directories and placeholder
files with educational comments for you. First we'll create a role called "commonrole". This will be a role that will have to be
called before other roles, so that it can provide common functionality.
```bash
ansible-galaxy init commonrole
cd commonrole
ls -l
```
So now you can see that there are quite a lot of directories. For our first version, we'll focus only on ./defaults and ./tasks.
In ./defaults/main.yml we can put some default parameters that can be easily overwritten, as it is parsed first when calling the
role. We're gonna go ahead and put a parameter in there, so that we can test running our roles:
```bash
vi defaults/main.yml
```
```yml
---
commonrole_name: "Mr. Potato"
```
Then, we can create our task list that will be run when we call our role:
```bash
vi tasks/main.yml
```
```yml
---
# tasks file for commonrole
- name: Test 1 - Load default value
  debug:
    msg: "{{ commonrole_name }}"

- name: Test 2 - Export var
  set_fact:
    rb_commonrole_name: "{{ commonrole_name }}"
```
Notice that the var **commonrole_name** is automatically accessible because we put it in the ./defaults/main.yml file. This will
not be the case though for the next role that we call. We export it by using set_fact, so that our next role can use it.

Next we'll create our second role, that will be reliant on our "commonrole" role. Go back to the roles folder and create a new
role called "subrole1":
```
cd ..
ansible-galaxy init subrole1
```
Let's edit the tasks/main.yml file for this role so we can use the "rb_commonrole_name" variable and test whether everything is
working as intended:
```
vi subrole1/tasks/main.yml
```
```yml
---
# tasks file for subrole1
- name: Test 3 - Import var
  debug:
    msg: "{{ rb_commonrole_name }}"
```

The idea here is that commonrole will declare the variable rb_commonrole_name. Then commonrole will close, and subrole1
will be started, using rb_commonrole_name. Let's make a playbook that first calls commonrole, and then subrole1:
```bash
cd .. # go back to ansible directory root
vi test.yml
```
```yml
---
# tasks file for subrole1
- name: Test 3 - Import var
  debug:
    msg: "{{ rb_commonrole_name }}"
(ansible) [dorus@dorus-pc roles_1]$ cat test.yml 
- hosts: localhost
  tasks:
    - include_role:
        name: commonrole
    - include_role:
        name: subrole1
```
Alright, everything is set up, let's call the playbook. (n.b.: we need -v for ansible to show us the output of debug)
```bash
ansible-playbook test.yml -i localhost -v  # run playbook test.yml, with inventory as localhost, verbosity level 1
```
Output:
```
PLAY [localhost] ***************************************************************

TASK [Gathering Facts] *********************************************************
ok: [localhost]

TASK [include_role : commonrole] ***********************************************

TASK [commonrole : Test 1 - Load default value] ********************************
ok: [localhost] => {
    "msg": "Mr. Potato"
}

TASK [commonrole : Test 2 - Export var] ****************************************
ok: [localhost] => {"ansible_facts": {"rb_commonrole_name": "Mr. Potato"}, "changed": false}

TASK [include_role : subrole1] *************************************************

TASK [subrole1 : Test 3 - Import var] ******************************************
ok: [localhost] => {
    "msg": "Mr. Potato"
}

PLAY RECAP *********************************************************************
localhost                  : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

Note that if you try to debug "commonrole_name" in subrole1, that it will give you an error: it is not available.

Now, if we can say that commonrole will always have to be called before subrole1 is called, then we can add a dependency to 
subrole1. This will be achieved in the next section.
