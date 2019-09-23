MedCo Technical Documentation
*****************************

..  toctree::
    :hidden:

    system_admin/index
    developer/index
    user/index

*Disclaimer: MedCo is still an experimental software under development and should not, at this point, use real sensitive data.*


Releases
++++++++

    - | **0.2.1**, *15 Aug. 2019*
      | Implementation of additional query types (patient list, locally obfuscated count, global count, shuffled count),
        implementation of OIDC-based authorization model, implementation of CLI client, timers improvements, upgrade of
        dependencies, various smaller improvements and bug fixes.
    - | **0.2.0**, *3rd May 2019*
      | Architecture revisit, replaced *medco-i2b2-cell* by *medco-connector*, upgrades (IRCT v1.4 to PICSURE v2.0, Onet
        suite v3, Keycloak, Nginx, PHP), consolidation of deployment, many smaller fixes and enhancements.
    - | **0.1.1**, *23rd Jan. 2019*
      | Deployment for test purposes on several machines, enhancements of documentation and deployment infrastructure,
        Nginx reverse proxy with HTTPS support, Keycloak update.
    - | **0.1**, *1st Dec. 2018*
      | First public release of MedCo, running with i2b2 v1.7, PIC-SURE/IRCT v1.4 and centralized OpenID Connect
        authentication. Deployment for development and test purpose on a single machine.


Resources
+++++++++

- MedCo software repositories
    - `MedCo Connector <https://github.com/ldsec/medco-connector>`_
    - `Unlynx Wrapper <https://github.com/ldsec/medco-unlynx>`_
    - `Unlynx Javascript Crypto Library <https://github.com/ldsec/medco-unlynx-js>`_
    - `Data Loader <https://github.com/ldsec/medco-loader>`_
    - `Glowing Bear MedCo <https://github.com/ldsec/glowing-bear-medco>`_ (forked from `The Hyve <https://github.com/thehyve/glowing-bear>`_)
    - `Deployment <https://github.com/ldsec/medco-deployment>`_
    - `Documentation <https://github.com/ldsec/medco-documentation>`_

- Other resources
    - `Docker Hub organization <https://hub.docker.com/u/medco/>`_
    - `NPM.js organization <https://www.npmjs.com/package/@medco/medco-unlynx-js>`_

- Deprecated repositories
    - `IRCT <https://github.com/ldsec/IRCT>`_ (forked from `HMS-DBMI <https://github.com/hms-dbmi/IRCT>`_)
    - `I2B2 Cell <https://github.com/ldsec/medco-i2b2-cell>`_


Contact
+++++++

For assistance with deploying MedCo or any other technical questions, send an email at `medco-dev@listes.epfl.ch <mailto:medco-dev@listes.epfl.ch>`_ or any of the contributors.

- `Mickaël Misbach <https://github.com/mickmis>`_ (Privacy and Security Software Engineer, EPFL) - `mickael.misbach@epfl.ch <mailto:mickael.misbach@epfl.ch>`_
- `Joao Andre Sa <https://github.com/JoaoAndreSa>`_ (Privacy and Security Software Engineer, EPFL) - `joao.gomesdesaesousa@epfl.ch <mailto:joao.gomesdesaesousa@epfl.ch>`_
- `Jean Louis Raisaro <https://github.com/JLRgithub>`_ (Data Protection Specialist, CHUV) - `jean.raisaro@chuv.ch <mailto:jean.raisaro@chuv.ch>`_
- `Juan Troncoso-Pastoriza <https://github.com/jrtroncoso>`_ (Post-Doctoral Researcher, EPFL) - `juan.troncoso-pastoriza@epfl.ch <mailto:juan.troncoso-pastoriza@epfl.ch>`_
- `Jean-Pierre Hubaux <https://people.epfl.ch/jean-pierre.hubaux>`_ (Professor, EPFL) - `jean-pierre.hubaux@epfl.ch <mailto:jean-pierre.hubaux@epfl.ch>`_


License
+++++++

MedCo is licensed under a End User Software License Agreement ('EULA') for non-commercial use.
If you need more information, please contact us.
