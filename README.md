# Code golfing

## About
This project uses [R](https://www.r-project.org/) and [Python](https://www.python.org/).

## File map

- `./data` : data files
- `./R` : contains the `R` scripts
- `./python` : contains the `python` scripts

## How to code golf

1. Link a local repository with this remote repository
	+ `git init`
	+ `git remote add origin https://github.com/hrvg/code-golfing`
2. Pull the whole directory
	+ `git pull origin master`
3. Create your own branch
	+ `git branch branch-name`
4. Switch to your branch
	+ `git checkout branch-name`
4. Work on your own branch locally to test your code, commit and push your changes, ask questions online through the github interface.
	+ `git add .`
	+ `git commit -m "informative commit message"`
	+ `git push origin branch-name`

<<<<<<< f40d5ec6355c8c85e8ca80e606cbdde216fc0a4c
<<<<<<< 1833d96f3a3be873a9b954e9e36933bf9d78729a
## How to update to the new question

From your branch: (`git status` or `git checkout branch-name` to be sure):
1. `git rebase master`
2. `git add .`
3. `git rebase --continue`
4. `git checkout master`
5. `git pull origin master`
6. `git checkout branch-name`
7. `git rebase master`

=======
=======
	
>>>>>>> commit test
>>>>>>> commit test
=======
>>>>>>> Testing
## Code Golf 1: Tinkering with data

The instructions are in the `CG1_tinkering_with_data.*` files that you can found in their respective programming language folder.
The file `./data/sacramento-bendbridge-paleo.csv` contains yearly flow data from 900 to 2017 for the Sacramento River at Bend Bridge, in acre-feet. 
This is a very important location for water supply in California!
A function to read the data file is already defined in each of the script.
Use this function template to perform all the tasks required in the `TODO`section.

Searching the manual, googling and searching Stack Overflow is recommended.

Estimated work-load: 20 min.

## Code Golf 2: Identifying Dry Years

The instructions are in the `CG2_identifying_dry_years.*` files that you can found in their respective programming language folder.
The file `./data/sacramento-bendbridge-paleo.csv` contains yearly flow data from 900 to 2017 for the Sacramento River at Bend Bridge, in acre-feet. 
This is a very important location for water supply in California!
A function to read the data file is already defined in each of the script.
Use this function template to perform all the tasks required in the `TODO` section.

Searching the manual, googling and searching Stack Overflow is recommended.

Estimated work-load: 30 min.


## License

Copyright (c) 2018

Licensed under the [MIT license](LICENSE).