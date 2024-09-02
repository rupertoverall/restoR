# https://github.com/rupertoverall/restoR/

sep = "/" # Not sure how this is handled in Windows.
library = .libPaths()
libpath = strsplit(library, split = sep, perl = T)[[1]]
version.index = which(libpath == "Versions") + 1
this.version.number = as.numeric(strsplit(libpath[version.index], "-")[[1]][1]) # MacOS now has platform identifers.
all.versions = sapply(strsplit(list.files(paste(libpath[1:(version.index - 1)], collapse = sep)), "-"), "[", 1)
all.version.numbers = suppressWarnings( as.numeric(sapply(strsplit(all.versions, "-"), "[", 1)) )
all.version.order = order(as.numeric(all.version.numbers), decreasing = T)
all.versions = all.versions[all.version.order]
all.version.numbers = all.version.numbers[all.version.order]
last.version = all.versions[which(all.version.numbers < this.version.number)[1]]
last.library = libpath
all.libraries = list.dirs(paste(libpath[1:(version.index - 1)], collapse = sep), recursive = FALSE)
all.libraries.versions = sapply(all.libraries, function(library) strsplit(library, split = sep, perl = T)[[1]][version.index] )
last.version.string = all.libraries.versions[which(grepl(last.version, all.libraries.versions))]
last.library[version.index] = last.version.string
last.library = paste(last.library, collapse = sep)

previous.packages = installed.packages(lib.loc = last.library)
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
