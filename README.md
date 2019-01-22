# Documentation of the MedCo Project
The `master` branch is served using github pages: 
https://lca1.github.io/medco-documentation/

The `dev` branch contains the sources in reStructuredText format.

## Build HTML files
**Dependency**: *Docker*

In order to build the HTML files in the `docs/` folder, 
simply run from the root of the repository:
```bash
make html
```

## Push on Github Pages
Run the following to push the previously compiled HTML website on the `master` branch:
```bash
./gh-pages-push.sh
```

# License
*medco-documentation* is licensed under a End User Software License Agreement ('EULA') for non-commercial use.
If you need more information, please contact us.
