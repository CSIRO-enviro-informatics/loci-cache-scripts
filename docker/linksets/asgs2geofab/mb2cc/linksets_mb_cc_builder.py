import zipfile
import os
import logging
from locilinksetutils import linksets_builder
from locilinksetutils import utils
logging.basicConfig(level=logging.DEBUG)
asgs_2016_local_name_prefix = "mb_2016_all_shape"



def get_meshblock_assets():
    logging.info("Downloading asgs 2016 spatial data")
    utils.get_s3_assets(asgs_2016_local_name_prefix, linksets_builder.s3_bucket, linksets_builder.s3_source_data_path + linksets_builder.s3_asgs_2016_mb_path)




def load_asgs_mb():
    '''
    Load ASGS Mesh Blocks into PostGIS
    Note: `-nlt MULTIPOLYGON` is specified here, because by default it will ingest as MULTISURFACE, which doesn't work well for our use-case.
    There will be some errors when it tries to import from_pt, because it POINTS don't work with MULTIPOLYGON layer types. Ignore this. We don't use mb_pt
    All ASGS coords are in crs EPSG:3857, this needs to be transformed to albers (EPSG:3577) in the sql query in order to do constant-area intersections with catchments 
    eg: ST_Transform(shape, 3577)
    '''
    logging.info("Loading asgs meshblocks")
    linksets_builder.load_via_ogr("../assets/{}/MB_MB.shp".format(asgs_2016_local_name_prefix), "from")
    from_id_column = "mb_code_20"
    return from_id_column 


if __name__ == "__main__":
    #Generic preparation logic
    linksets_builder.prepare_database()

    #Specific meshblock and catchment logic TODO: This and generic logic will be seperated further in future refactors
    linksets_builder.get_geofabric_assets()
    get_meshblock_assets()
    load_from_data = load_asgs_mb
    load_to_data = linksets_builder.load_geofabric_catchments
    from_id_column = load_from_data()
    to_id_column = load_to_data()

    # Generic linksets builder logic
    linksets_builder.build_linkset(from_id_column, to_id_column)
