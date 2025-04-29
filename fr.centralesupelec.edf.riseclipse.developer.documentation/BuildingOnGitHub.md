----
Copyright (c) 2023-2025 CentraleSupélec & EDF.

All rights reserved. This program and the accompanying materials
are made available under the terms of the Eclipse Public License v2.0
which accompanies this distribution, and is available at
https://www.eclipse.org/legal/epl-v20.html

This file is part of the RiseClipse tool
 
**Contributors:**
 * Computer Science Department, CentraleSupélec
 * EDF R&D

**Contacts:**
 * dominique.marcadet@centralesupelec.fr
 * aurelie.dehouck-neveu@edf.fr

**Web site:**
 * https://riseclipse.github.io/
----

## Scenario

This scenario corresponds to the building and deployment of RiseClipse components and tools on GitHub. It starts from the state after `BuildingOnLocalMachine`.



## Process

- Go to `riseclipse-developer`
    - Edit `fr.centralesupelec.edf.riseclipse.developer.maven/pom.xml`:
        - Update `project.properties.*`:
            - Update `.riseclipse-target-platform-version` with `project.version` **without** `-SNAPSHOT`

    - Edit `fr.centralesupelec.edf.riseclipse.developer.p2_to_m2/pom.xml`
        - Update `project.version` and `project.parent.version` to be the same as `project.version` from `fr.centralesupelec.edf.riseclipse.developer.maven/pom.xml` (**without** `-SNAPSHOT`)
        - The rationale for this is: `p2_to_m2` will not be deployed on Maven Central, but it will be used when building the validators, and the version used for this will be obtained from the `riseclipse-developer/fr.centralesupelec.edf.riseclipse.developer.maven/pom.xml` deployed on Maven Central

    - Commit to `develop`

    - Push to GitHub

    - Merge `develop` to `master`

    - Run workflow `Release on Maven Central`

    - Merge PR **prepare for next development iteration after release** on GitHub, deleting the `do_release` branch

    - For the next builds to succeed, the new version of `riseclipse-developer` must be available on [Maven Central](https://central.sonatype.com/artifact/io.github.riseclipse/riseclipse-developer/versions)

- Go to `riseclipse-main`
    - Edit `riseclipse-main/pom.xml`
        - Update `project.parent.version` to be the same as `project.version` from `fr.centralesupelec.edf.riseclipse.developer.maven/pom.xml` (**without** `-SNAPSHOT`)

    - Commit to `develop` and continue like above

- Go to `riseclipse-validator-ocl`:
    - Edit `pom.xml`:
        - Update `project.parent.version` to be the same as `project.version` from `fr.centralesupelec.edf.riseclipse.developer.maven/pom.xml` (**without** `-SNAPSHOT`)

    - Edit `fr.centralesupelec.edf.riseclipse.validation.ocl/pom.xml`:
        - Update version of dependency `fr.centralesupelec.edf.riseclipse.main` to be the same as `project.version` from `riseclipse-main/pom.xml` (**without** `-SNAPSHOT`)

    - Commit to `develop` and continue like above



