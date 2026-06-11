----
Copyright (c) 2026 CentraleSupélec & EDF.

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

This scenario describes the deployment of a develop version of tools.

The expected initial state is:
- The needed RiseClipse git projects are available on the computer
- All components and tools are on the `develop` branch
    - When an issue has to be corrected, a branch is created from `develop`, the fix is
      done in this new branch, a MR to `develop` is created and applied when approved
- The maven versions are **with** `-SNAPSHOT`


## Technical details
- A maven profile `deploy-snapshots` defined in `riseclipse-developer/fr.centralesupelec.edf.riseclipse.developer.maven/pom.xml`
  is used
- The develop components are deployed and consumed on Central Portal Snapshots repository


## Process

- Go to `riseclipse-developer`
    - Check `fr.centralesupelec.edf.riseclipse.developer.maven/pom.xml`:
        - Check `project.version`: **with** `-SNAPSHOT`
        - Check `project.properties.riseclipse-target-platform-version`: **same as** `project.version`

    - Check `fr.centralesupelec.edf.riseclipse.developer.p2_to_m2/pom.xml`:
        - Check `project.version` and `project.parent.version`: **same as** `project.version` 
          from `fr.centralesupelec.edf.riseclipse.developer.maven/pom.xml` (**with** `-SNAPSHOT`)

    - Commit to `develop` if needed

    - Push to GitHub if needed

    - The workflow `Release snapshots on Maven Central` is run after a push to `develop`. It may
      also be triggered manually if needed (**choose** the `develop` branch!)
        - Check its success

    - For the next builds to succeed, the develop version of `riseclipse-developer` must 
      be available on [Maven Central Snapshots](https://central.sonatype.com/repository/maven-snapshots/)
      (not browsable at the time of writing)

- Go to `riseclipse-main`
    - Check `riseclipse-main/pom.xml`:
        - Check `project.version`: **with** `-SNAPSHOT`
        - Check `project.parent.version`: **same as** `project.version` from 
          `fr.centralesupelec.edf.riseclipse.developer.maven/pom.xml` (**with** `-SNAPSHOT`)
    - Check `riseclipse-main/fr.centralesupelec.edf.riseclipse.main/pom.xml`:
        - Check `project.version` and `project.parent.version`: **same as** `project.version` 
          from `riseclipse-main/pom.xml`
    - Check `riseclipse-main/fr.centralesupelec.edf.riseclipse.main/META-INF/MANIFEST.MF`:
      `Bundle-Version` **same as** `project.version` from `riseclipse-main/pom.xml` **but with**
      `.qualifier` **instead of** `-SNAPSHOT`

    - Commit to `develop` if needed

    - Push to GitHub if needed

    - The workflow `Release snapshots on Maven Central` is run after a push to `develop`. It may
      also be triggered manually if needed (**choose** the `develop` branch!)
        - Check its success

    - For the next builds to succeed, the develop version of `riseclipse-main` must 
      be available on [Maven Central Snapshots](https://central.sonatype.com/repository/maven-snapshots/)
      (not browsable at the time of writing)


- Go to `riseclipse-validator-ocl`, `riseclipse-metamodel-scl2003`, `riseclipse-metamodel-nsd2016`
    - Repeat the same steps as `riseclipse-main`
    - Also check the versions of RiseClipse dependencies: right values and **including** `-SNAPSHOT`
    - **Warning**: some repositories have several Eclipse projects


- Go to `riseclipse-validator-scl2003`
    - Update `TOOL_VERSION` ( **with** `-SNAPSHOT`) and `TOOL_DATE` in `RiseClipseValidatorSCL.java`
    - Update `CHANGELOG.md`

    - Commit to `develop` if needed

    - Push to GitHub if needed

    - Run manually the workflow `Deploy snapshot tool` (**choose** the `develop` branch!)

    - Switch to branch  `iec-61850-6-3-snapshot`
        - Merge branch `develop` into `iec-61850-6-3-snapshot`
        - Update `RELEASE_VERSION` in `.github/workflows/Release-On-DockerHub.yml`
        - Commit, push to GitHub
        - Trigger workflow with `gh workflow run .github/workflows/Release-On-DockerHub.yml --ref iec61850-6-3-snapshot`


