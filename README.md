# laravel-dev-env
simple way to run `artisan make:` commands during package development

## Usage

Copy this script into your project root during package development and (optionally) add it to your .gitignore
Create a laravel project in your project root and .gitignore it as well, and initialize a git repository inside the laravel project, then add and commit the skeleton
>NOTE:   
>This script uses git to list the file changes made by artisan commands.   
>Needless to say git is a requirement, as is a repository in the skeleton (with an initial commit).   
>You can also clone and install an existing laravel application of your own to use as your skeleton (instead of running `laravel new`)

e.g:
```bash
laravel new .laravel-skeleton
cd .laravel-skeleton
git init
git add .
git commit -m "skeleton"
```


create a .env file in your project root and set your package_namespace and skeleton_path e.g:

```env
skeleton_path=".laravel-skeleton"
package_namespace='MyOrganization\\MyPackage'
src_path="src"
```

use artisan to stub out your package classes like:

```bash
bash artisan.sh make:model MyModel -mfc
```
```

   INFO  Model [app/Models/MyModel.php] created successfully.  

   INFO  Factory [database/factories/MyModelFactory.php] created successfully.  

   INFO  Migration [database/migrations/2023_03_14_210942_create_my_models_table.php] created successfully.  

   INFO  Controller [app/Http/Controllers/MyModelController.php] created successfully.  

File: .laravel-skeleton/app/Http/Controllers/MyModelController.php
Path: src/Http/Controllers
Namespace: MyOrganization\\MyPackage
File: .laravel-skeleton/app/Models/MyModel.php
Path: src/Models
Namespace: MyOrganization\\MyPackage
File: .laravel-skeleton/database/factories/MyModelFactory.php
Path: database/factories
Namespace: MyOrganization\\MyPackage
File: .laravel-skeleton/database/migrations/2023_03_14_210942_create_my_models_table.php
Path: database/migrations
Namespace: MyOrganization\\MyPackage
```

and 

```bash
bash artisan.sh make:migration create_awesome_table
```
>NOTE:   
>Use triple backslash when double quoting namespaces, and double backslashes when single quoting'
