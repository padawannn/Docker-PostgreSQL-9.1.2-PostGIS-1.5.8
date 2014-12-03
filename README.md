Docker Image for PostgreSQL 9.1.2 / PostGIS 1.5.8
=================================================

Why?
----
Because:

  - we want to reach a minimum level of proficiency with Docker, a wonderful
    technology new to us;

  - it's a developing and production environment setting we based a lot of
    projects on in the past, and we still use it in mantienance tasks.

What does this Docker image contains?
-------------------------------------
Compiled from source, this is what this image contains:

  - PostgreSQL 9.1.2;
  - PROJ 4.8.0, patched to support the NTv2 Spanish national grid for datum
    shiftings between ED50 and ETRS89;
  - GEOS 3.4.2;
  - PostGIS 1.5.8, also patched to support the spanish national grid.

Usage Pattern
-------------
Build the image directly from GitHub:

    docker build -t="malkab/postgresql-9.1.2-postgis-1.5.8"
    git@github.com:malkab/dock

or pull it from Docker Hub:

    docker pull jj/kk

Then create a new data storage:
