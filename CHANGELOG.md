## v0.0.8

- fix(ci): fix pub.dev publishing missing devtools build artifacts (#20)

## v0.0.7

- feat: rewrite create-release.yml to use OIDC for pub.dev publish (#18)
- perf: optimize point-in-rectangle overlap check (#13)
- 🧪 test general exception on widget move (#14)
- 🧪 testing improvement: add missing edge case test for DashboardGridChangeSnapshot (#15)
- test: add tests for DashboardWidget.copyWith (#12)
- Refactor: Extract common state update logic in DashboardGrid (#10)
- perf: Optimize _findDifference by reducing O(N^2) list searches to O(N) with Map (#11)
- test: Add tests for TableCellDecoration (#9)
- perf: optimize O(N^2) list difference calculation in DashboardGrid (#8)
- test: add tests for TableCellDelegate property setters (#7)
- Fix: Use env context instead of secrets in GitHub Actions if condition (#6)
- ⚡ Optimize Map key lookup to constant time in layout table (#5)
- feat: Add GitHub Actions workflow for creating releases and updating CHANGELOG
- docs: Add missing documentation to public APIs
- Add documentation files for WARP and Gemini code assistant context (#4)

## 0.0.5

* Allow dragging widgets inside their boundaries
* Initial support for dev extension
* Fix for propagating config for widget width/height and spacing


## 0.0.5

* It is possible now specify size of the widget and spacing between them
* Default constants for width/height/spacing is exported


## 0.0.4

* Support for height more than 1


## 0.0.3

* Fix for crash when widget size is different to 1x1
* Exported `TableCellDecoration`


## 0.0.2

* Added cell preview decoration configurable
* Added callback to notify when widget collection in config has changed, provides snapshot with `from` and `to` changes

## 0.0.1

* Initial release, project skeleton without actual code
