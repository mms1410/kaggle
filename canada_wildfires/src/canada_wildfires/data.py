import kagglehub
from pathlib import Path
from yaml import safe_load
import geopandas as gpd

root = Path.cwd()
with Path(root, "conf", "config").with_suffix(".yaml").open("r") as configfile:
    conf = safe_load(configfile)

data_folder = Path(root, "data")
assets_folder = Path(root, "assets")

data_folder.mkdir(parents = False, exist_ok = True)
assets_folder.mkdir(parents = False, exist_ok = True)

kagglehub.dataset_download("ulasozdemir/wildfires-in-canada-19502021",
                                  output_dir = data_folder)

world = gpd.read_file(conf["world"])
canada = world[world["NAME"] == "Canada"]
canada = canada.set_geometry("geometry")
canada.to_crs(conf["crs"])
canada.to_parquet(Path(assets_folder, "canada.pq"), index = False)


