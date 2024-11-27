locals {
  common_tags = {
    Environment   = "${var.env}"
    BuildingBlock = "${var.building_block}"
  }
}