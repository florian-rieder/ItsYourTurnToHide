"""
Automates exports of a godot project

Dependencies:
- zipfile
"""

import os, shutil
from zipfile import ZipFile 

TITLE = "ItsYourTurnToHide"
VERSION = "1.0.2"

EXPORTS_FOLDER = "./bin"

EXPORTS = {
    "windows": {
        "template_name": "Windows Desktop",
        "export_file_extension": "exe"
    },
    "mac": {
        "template_name": "Mac OSX",
        "export_file_extension": "zip"
    },
    "linux": {
        "template_name": "Linux/X11",
        "export_file_extension": "x86_64"
    },
    "web": {
        "template_name": "HTML5",
        "export_file_extension": "html"
    },
}


def main():
    if not os.path.exists("project.godot"):
        print("Couldn't find a project.godot file in this directory.")
        return

    if not os.path.exists(EXPORTS_FOLDER):
        os.makedirs(EXPORTS_FOLDER)
    
    for platform, properties in EXPORTS.items():
        platform_dir = "%s/%s" % (EXPORTS_FOLDER, platform)

        # check if a platform specific directory exists
        if not os.path.exists(platform_dir):
            os.makedirs(platform_dir)
        else:
            empty_folder(platform_dir)

        export_name = "%s/%s" % (platform_dir, "index" if platform == "web" else TITLE)
        
        # launch export for this platform
        os.system('godot --export "%s" %s' % (properties["template_name"], export_name))

        # once export is done, rename the executable with its file extension
        os.rename(export_name, "%s.%s" % (export_name, properties["export_file_extension"]))
    
    # zip files for each platform
    for platform in EXPORTS.keys():
        make_zip(platform)

def make_zip(platform):
    platform_dir = "%s/%s" % (EXPORTS_FOLDER, platform)
    archive_name = '%s/%s_%s_%s.zip' % (platform_dir, TITLE, platform, VERSION)

    file_paths = get_all_file_paths(platform_dir)

    with ZipFile(archive_name,'w') as zip_archive: 
        for file in file_paths: 
            zip_archive.write(file) 
    

def get_all_file_paths(directory): 
    file_paths = list()

    for root, _directories, files in os.walk(directory): 
        for filename in files:
            filepath = os.path.join(root, filename) 
            file_paths.append(filepath) 

    return file_paths         


def empty_folder(folder):
    for filename in os.listdir(folder):
        file_path = os.path.join(folder, filename)
        try:
            if os.path.isfile(file_path) or os.path.islink(file_path):
                os.unlink(file_path)
            elif os.path.isdir(file_path):
                shutil.rmtree(file_path)
        except Exception as e:
            print('Failed to delete %s. Reason: %s' % (file_path, e))

if __name__ == "__main__":
    main()