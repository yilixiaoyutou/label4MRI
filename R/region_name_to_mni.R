#' @title
#' Output the MNI coordinates of brain regions defined by AAL/BA system
#' @description
#' Input a brain region name, output the corresponding MNI coordinates.
#' This is the inverse function of the function \code{mni_to_region_name()}.
#' @param region_names A character vector which indeicates the brain region names of interest.
#'   Use \code{list_brain_regions()} to see all brain region names defined by AAL/BA system.
#' @param template One character value which indicates the templates to use
#'   (\code{"aal"} or \code{"ba"}). Use \code{"aal"} by default.
#' @return
#' Return a list of data frames and each of them correspond to a template.
#' Each data frame consists the MNI coordinates of the input brain region.
#' @seealso
#' \code{\link{mni_to_region_name}} \cr
#' \code{\link{list_brain_regions}}
#' @examples
#' # Get the MNI cooridnates of the right precentral region
#' # defined by AAL template
#' region_name_to_mni(region_names = "Precentral_R", template = "aal")
#'
#' # Get the MNI cooridnates of both the right and left precentral region
#' # defined by AAL template
#' region_name_to_mni(
#'   region_names = c("Precentral_R", "Precentral_L"),
#'   template = "aal"
#' )
#' @export

region_name_to_mni <- function(region_names, template = "aal") {
  if (length(template) > 1) {
    stop(paste0("Only one template is allowed at a time."))
  }

  if_template_exist <- template %in% names(label4mri_metadata)
  if (if_template_exist == F) {
    stop(paste0("Template `", template, "` does not exist."))
  }

  if_regions_exist <-
    region_names %in% label4mri_metadata[[template]]$label$Region_name
  if (sum(!if_regions_exist) != 0) {
    stop(paste0("Region `", paste(region_names[!if_regions_exist], collapse = ", "), "` does not exist."))
  }

  list_mni_coordinates <- lapply(
    region_names,
    function(.region_name) {
      region_index <- region_name_to_index(.region_name, template)
      region_index_to_mni(region_index, template)
    }
  )

  names(list_mni_coordinates) <- paste(
    rep(template, times = length(region_names)),
    region_names,
    sep = "."
  )

  list_mni_coordinates
}
