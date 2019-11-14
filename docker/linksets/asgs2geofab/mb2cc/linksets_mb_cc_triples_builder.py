from locilinksetutils import linksets_triples_builder
from locilinksetutils import utils
import logging

logging.basicConfig(level=logging.DEBUG)

if __name__ == "__main__":
    database_url = utils.fail_or_getenv('DATABASE_URL')
    contact_name = utils.fail_or_getenv('CONTACT_NAME')
    contact_email = utils.fail_or_getenv('CONTACT_EMAIL')
    header_description = """This LOC-I Project Linkset relates Meshblock individuals in the ASGS LOC-I Dataset to Contracted Catchment individuals in the Geofabric LOC-I Dataset. All Meshblock -> Catchment relations are either transitiveSfOverlap, sfWithin, or sfContains. That is a Meshblock either overlaps or is wholly within the Catchment, or in some cases the Meshblock wholly contains the Catchment.
    The Linkset triples (Meshblock sfWithin Catchment, Meshblock sfContains Catchment, Meshblock transitiveSfOverlap Catchment) are reified so that each triple is contained within an RDF Statement class instance so that the triple is numbered and the method used to generate the triple is given by the loci:hadGenerationMethod.
    The method used for all triples in this Linkset is the same and it is SpatialIntersection which is defined below.
    The triples for the main data in this linkset - the Statements relating Meshblocks to Catchments - are valid RDF in the Turtle syntax but an unusual namespacing arrangement is used so all terms are indicated with as few letters as possible, mostly one letter then colon, e.g. s: for http://www.w3.org/1999/02/22-rdf-syntax-ns#subject, rather than the more common rdf:subject. This is simply to reduce file size.
    """
    header_title = "Meshblocks Contracted Catchments Linkset"
    to_id_column = "hydroid"
    from_id_column = "mb_code_20"
    subjects_target = "http://linked.data.gov.au/dataset/asgs2016"
    objects_target = "http://linked.data.gov.au/dataset/geofabric"
    from_prefix = "http://linked.data.gov.au/dataset/asgs2016/meshblock/"
    to_prefix = "http://linked.data.gov.au/dataset/geofabric/contractedcatchment/"
    provenance_comment = "The method used to classify Meshblock and Contracted Catchment relationships"
    linkset_triples_builder.database_url = database_url
    linkset_triples_builder.do_withins(from_id_column, to_id_column)
    linkset_triples_builder.do_overlaps(from_id_column, to_id_column)
    linkset_triples_builder.generate_header(header_description, header_title, contact_name, contact_email, from_prefix, to_prefix, subjects_target, objects_target, provenance_comment)
    linkset_triples_builder.concat_files("ls_mb16cc.ttl")