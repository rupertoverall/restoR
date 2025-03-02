# https://github.com/rupertoverall/restoR/

sep = "/"

# Different platforms store the library info differently. Work through some possibilities:
# Get system information.
system.info = list(
  os = Sys.info()["sysname"],
  r.version = paste(R.version$major, R.version$minor, sep="."),
  r.upgrade.version = paste(R.version$major, as.integer(R.version$minor), sep="."),
  user.home = path.expand("~")
)
# Get library paths.
system.libraries = character(0)
user.libraries = character(0)
for(path in .libPaths()){
  if(grepl(system.info$user.home, path, fixed = TRUE)){
    user.libraries = c(user.libraries, path)
  }else{
    system.libraries = c(system.libraries, path)
  }
}

# Work through each previously-installed library and collect the missing packages.
previous.packages = do.call("rbind", lapply(c(user.libraries, system.libraries), function(library){
	path.components = strsplit(library, sep)[[1]]
	version.index = grep(system.info$r.upgrade.version, path.components)
	all.paths = list.files
	all.versions = list.files(paste(path.components[1:(version.index - 1)], collapse = sep))
	all.version.order = order(suppressWarnings( as.numeric(sapply(strsplit(all.versions, "-"), "[", 1)) ), decreasing = TRUE)
	last.version = all.versions[all.version.order[2]]
	if(!is.na(last.version)){
		previous.library.components = path.components
		previous.library.components[version.index] = last.version
		previous.library = paste(previous.library.components, collapse = sep)
		return(installed.packages(lib.loc = previous.library))
	}else{
		#stop("There are no previous R installations to be found.")
		return(NULL)
	}
}))

##

# Now install all of the missing packages.
required.packages = setdiff(previous.packages[, "Package"], installed.packages()[, "Package"])
if(!require("BiocManager", quietly = TRUE)) install.packages("BiocManager", ask = FALSE)
for(package in required.packages){
	print(package)
	tryCatch({
		if(!require(package, quietly = TRUE)) BiocManager::install(package, ask = FALSE)
	}, error = function(cond){
		install.packages(package)
		if(!require(package, quietly = TRUE)) message(paste0("Package '", package, "' not installable."))
	})
}

still.required.packages = setdiff(required.packages, installed.packages()[, "Package"])
print(still.required.packages) # These will have to be dealt with manually.
