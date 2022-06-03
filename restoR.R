sep = "/" # Not sure how this is handled in Windows.
library = .libPaths()
libpath = strsplit(library, split = sep, perl = T)[[1]]
version.index = which(libpath == "Versions") + 1
this.version = libpath[version.index]
all.versions = list.files(paste(libpath[1:(version.index - 1)], collapse = sep))
all.version.numbers = sort(as.numeric(all.versions), decreasing = T)
last.version = all.versions[which(all.version.numbers < as.numeric(this.version))[1]]
last.library = libpath
last.library[version.index] = last.version
last.library = paste(last.library, collapse = sep)

previous.packages = installed.packages(lib.loc = last.library)
required.packages = setdiff(previous.packages[, "Package"], installed.packages()[, "Package"])
if(!require("BiocManager", quietly = TRUE)) install.packages("BiocManager")
for(package in required.packages){
	print(package)
	tryCatch({
		if(!require(package, quietly = TRUE)) BiocManager::install(package)
	}, error = function(cond){
		install.packages(package)
		if(!require(package, quietly = TRUE)) message(paste0("Package '", package, "' not installable."))
	})
}

still.required.packages = setdiff(required.packages, installed.packages()[, "Package"])
print(still.required.packages) # These will have to be dealt with manually.
