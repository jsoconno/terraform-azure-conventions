#!/usr/bin/env python

import yaml
from pathlib import Path

# This script automatically creates the outputs.tf file

def format_standard(resource, acronym):
    return f'output "{resource}" {{\n  value = "{acronym}${{local.convention}}"\n  description = "Naming convention for the resource {resource}."\n}}\n\n'

def format_alphanumeric_lowercase_only(resource, acronym):
    return f'output "{resource}" {{\n  value = "{acronym}${{lower(replace(local.convention, "-", ""))}}"\n  description = "Naming convention for the resource {resource}.  This resource requires alphanumeric and lowercase values only."\n}}\n\n'

def format_alphanumeric_only(resource, acronym):
    return f'output "{resource}" {{\n  value = "{acronym}${{replace(local.convention, "-", "")}}"\n  description = "Naming convention for the resource {resource}.  This resource requires alphanumeric values only."\n}}\n\n'

def format_lowercase_only(resource, acronym):
    return f'output "{resource}" {{\n  value = "{acronym}${{lower(local.convention)}}"\n  description = "Naming convention for the resource {resource}.  This resource requires lowercase values only."\n}}\n\n'

def format_alphanumeric_underscore_only(resource, acronym):
    return f'output "{resource}" {{\n  value = "{acronym}${{lower(replace(local.convention, "_", ""))}}"\n  description = "Naming convention for the resource {resource}.  This resource requires alphanumeric and underscore values only."\n}}\n\n'

def build_resource_acronyms(resource_list=[]):
    """
    Automatically generate unique naming conventions for resources.
    """
    resource_acronyms = {}

    for resource in resource_list:
        resource_name_components = resource.lower().replace("azurerm_", "").split("_")
        resource_name_last = resource_name_components[-1]
        if len(resource_name_components) == 1:
            resource_base_acronym = resource_name_components[0][:3]
        else:
            resource_base_acronym = [word[0] for word in resource_name_components]
            resource_base_acronym = ''.join(resource_base_acronym)

        counter = 2
        acronym = resource_base_acronym

        print(f'Generating acronym for {resource}.')
        while acronym in resource_acronyms:
            print(f'{acronym} cannot be used for {resource} because it already is used by {resource_acronyms[acronym]}.')
            acronym = resource_base_acronym[:-1] + resource_name_last[:counter]
            print(f'Trying to use the acronym {acronym}.')
            counter += 1

        print(f'The acronym {acronym} was generated for {resource}.')
        resource_acronyms[acronym] = resource

    return resource_acronyms

def build_terraform_output_file(acronym_dictionary={}):
    """
    Creates a Terraform outputs.tf file that contains the naming conventions.
    """
    with open("outputs.tf", 'a') as terraform_outputs:
        terraform_outputs.truncate(0)
        for acronym, resource in acronym_dictionary.items():
            if resource in alphanumeric_lowercase_only:
                terraform_outputs.write(format_alphanumeric_lowercase_only(resource=resource, acronym=acronym))
            elif resource in alphanumeric_only or resource in length_restricted:
                terraform_outputs.write(format_alphanumeric_only(resource=resource, acronym=acronym))
            elif resource in lowercase_only:
                terraform_outputs.write(format_lowercase_only(resource=resource, acronym=acronym))
            elif resource in alphanumeric_underscore_only:
                terraform_outputs.write(format_alphanumeric_underscore_only(resource=resource, acronym=acronym))
            else:
                terraform_outputs.write(format_standard(resource=resource, acronym=acronym))

    return terraform_outputs

def read_yaml(path, selection=None):
    """
    A function that reads yaml files and allows the user to select what
    data they want returned specifically, if desired.
    """
    with open(path, "r") as resources:
        try:
            result = yaml.safe_load(resources)
            if selection:
                result = result[selection]
        except yaml.YAMLError as exc:
            result = {}
            print(exc)
    
    return result

resources_path = f'{Path(__file__).parent.parent}/.config/.resources.yml'
restrictions_path = f'{Path(__file__).parent.parent}/.config/.restrictions.yml'

resources = read_yaml(path=resources_path, selection="resources")

alphanumeric_lowercase_only = read_yaml(path=restrictions_path, selection="alphanumeric_lowercase_only")
alphanumeric_only = read_yaml(path=restrictions_path, selection="alphanumeric_only")
lowercase_only = read_yaml(path=restrictions_path, selection="lowercase_only")
alphanumeric_underscore_only = read_yaml(path=restrictions_path, selection="alphanumeric_underscore_only")
length_restricted = read_yaml(path=restrictions_path, selection="length_restricted")

output = build_resource_acronyms(resource_list=resources)
build_terraform_output_file(output)