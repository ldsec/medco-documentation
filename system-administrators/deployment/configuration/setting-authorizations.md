---
description: This page guide you on how to set authorizations to users through Keycloak.
---

# Setting Authorizations

You will find below the documentation for each authorization available in MedCo. [Follow this section to know how to modify those authorizations for your users.](keycloak.md#give-query-permissions-to-a-user)

## Authorizations

### REST API Authorizations

Those authorizations allow the user to interact with API endpoints of the MedCo connector. 

{% hint style="warning" %}
The minimum set of authorizations needed for users to use MedCo is the following:

* `medco-network`
* `medco-explore`
* `medco-genomic-annotations`
{% endhint %}

#### medco-network

This covers the calls related to the network metadata: list of nodes, keys, URLs, etc.

#### medco-explore

This covers the calls related to the building and requesting of explore queries and cohort saving. Note that an additional authorization among the [explore query authorizations](setting-authorizations.md#explore-query-authorizations) is needed to be able to make explore queries.

#### medco-genomic-annotations

This covers the genomic annotations auto-completion and the querying of genomic variants.

#### medco-survival-analysis

This covers the calls needed for requesting computations of survival curves.

### Explore Query Authorizations

Those authorizations set the types of result users will be able to get when making an explore query.

{% hint style="info" %}
Those authorizations are ordered according to their precedence. This means that if a user has several of them, the authorization with the highest level will be selected.
{% endhint %}

1. `patient_list`: exact counts and list of patient identifiers from all sites
2. `count_per_site`: exact counts from all sites
3. `count_per_site_obfuscated`: obfuscated counts from all sites
4. `count_per_site_shuffled`: exact counts from all sites, but without knowing which count came from which site
5. `count_per_site_shuffled_obfuscated`: obfuscated counts from all sites, but without knowing which count came from which site
6. `count_global`: exact aggregated global count
7. `count_global_obfuscated`: obfuscated \(at the site level\) aggregated global count



