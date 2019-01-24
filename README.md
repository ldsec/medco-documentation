# Documentation of the MedCo Project
The `docs/` folder is served using github pages: 
https://medco.epfl.ch/documentation/

The `source/` folder contains the sources in reStructuredText format.

## Build HTML files locally
**Dependency**: *Docker*

In order to build the HTML files locally in the `docs/` folder, 
simply run from the root of the repository:
```bash
make html
```

## Push sources and publish HTML on Github Pages
In order to commit and push the updated sources, and publish the HTML files on Github pages, 
simply run from the root of the repository:
```bash
make publish
```

# License
*medco-documentation* is licensed under a End User Software License Agreement ('EULA') for non-commercial use.
If you need more information, please contact us.
