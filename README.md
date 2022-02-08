
# matrix-docker

A docker-compose configuration of Synapse, Element Web Client and some additional components with focus on privacy.


## Goal

The goal of this project is to provide a Matrix setup which

1. has strong default privacy settings (e.g. room encryption defaults) and
2. still allows federation with other users on the Matrix network

---

**Please note:** This is work in progress. At the moment it is **not clear**, to what extent both of these goals can be achieved.
Quite a few settings have to be checked and their effect to be tested.

---

### Yet another matrix tutorial?

There are lots of tutorials out there already on how to install Matrix using Docker. For example, the [Matrix documentation](https://matrix-org.github.io/synapse/latest/setup/installation.html) itself recommends the [Ansible playbook by Slavi Pantaleev](https://github.com/spantaleev/matrix-docker-ansible-deploy). It was also referred to recently in a [heise.de Matrix tutorial article](https://www.heise.de/ratgeber/Eigener-Chatserver-Mit-dem-Matrix-Server-einen-Messaging-Dienst-betreiben-6289020.html).

However, this Ansible playbook tries to be exhaustive as possible, including **many** applications/services/plugins/bridges. But this is simply overwhelming if you want to start simple and small. Also, when not familiar with Ansible, it is hard to figure out, which services will be enabled at all and what the exact configuration of each service will be. That makes it difficult to be aware of the overall privacy situation of your setup.


## Components

---

**Please note:** This is subject to change as I move forward with the research. Further components/services might be added to extend the features of the Matrix server setup.

---

As of now, the setup consists of the following components:

- Synapse Matrix server
- PostgresDB
- Element Web Client
- Caddy as reverse proxy

Additional planned components:

- Identity Server (ma1sd)
- Integration Server (probably dimension)
- TURN server
- Synapse Admin interface
- matrix-registration (for tokenized self-registration)

After that, I may think about adding some bots or bridges (e.g. Telegram).


## Background

While many of the aspects of Matrix are very appealing (e.g. open source, decentralisation and federation, lots of bridges, e2e encryption, etc.), most of the installation instructions do not focus that much on the configuration of the Matrix homeserver with regard to privacy aspects.

Due to the nature of the federation in the Matrix network, some features obviously do require data exchange with other servers (e.g. messsaging a user on a federated server). Some other features, however, may not always be required or desired, e.g. allowing lookup of users on your Matrix server by 3PID (3rd-party identifiers, e.g. email).

Unfortunately, many default settings of a standard Matrix installation (i.e. Synapse and Element) do not promote privacy and/or rely on external servers (`matrix.org` and `vector.im`, the company behind the Element Matrix client).

There has been a quite thorough analysis of such a Matrix default setup with regard to data privacy published on [Gitlab](https://gitlab.com/libremonde-org/papers/research/privacy-matrix.org) and [Github](https://gist.github.com/maxidorius/5736fd09c9194b7a6dc03b6b8d7220d0). This publication was followed by some lengthy dispute between the authors of this research and some of the people behind Matrix/Synapse:

- Discussion on Hacker News: https://news.ycombinator.com/item?id=20178267
- Detailed response of the matrix.org people: https://matrix.org/~matthew/Response_to_-_Notes_on_privacy_and_data_collection_of_Matrix.pdf
- Official matrix.org blog post referring to this discussion and providing some thoughts on improving the privacy: https://matrix.org/blog/2019/06/30/tightening-up-privacy-in-matrix


## Additional Resources

This serves as a link collection of interesting resources with regard to setting up your own Matrix server:

- Guides on matrix.org: https://matrix.org/docs/guides
- Official Synapse documentation: https://matrix-org.github.io/synapse/latest/welcome_and_overview.html
- Official Synapse Docker image on Docker Hub: https://hub.docker.com/r/matrixdotorg/synapse
- A sample `docker-compose.yml` in the official GitHub repo: https://github.com/matrix-org/synapse/tree/develop/contrib/docker
- A blog post about installing Synapse, Element and Identity server including an example docker-compose file: https://zingmars.info/2019/12/29/Running-a-personal-Matrix-server-using-docker/
- The already mentioned exhaustive Ansible playbook by Slavi Pantaleev: https://github.com/spantaleev/matrix-docker-ansible-deploy

