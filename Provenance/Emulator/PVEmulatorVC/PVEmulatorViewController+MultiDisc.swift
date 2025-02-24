extension PVEmulatorViewController {
    func showSwapDiscsMenu() {
        guard let core = self.core as? (PVEmulatorCore & DiscSwappable) else {
            presentError("Internal error: No core found.")
            isShowingMenu = false
            enableControllerInput(false)
            return
        }

        let numberOfDiscs = core.numberOfDiscs
        guard numberOfDiscs > 1 else {
            presentError("Game only supports 1 disc.")
            core.setPauseEmulation(false)
            isShowingMenu = false
            enableControllerInput(false)
            return
        }

        // Add action for each disc
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        for index in 1 ... numberOfDiscs {
            actionSheet.addAction(UIAlertAction(title: "\(index)", style: .default, handler: { [unowned self] _ in

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    core.swapDisc(number: index)
                })

                core.setPauseEmulation(false)
                self.isShowingMenu = false
                self.enableControllerInput(false)
            }))
        }

        // Add cancel action
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: { [unowned self] _ in
            core.setPauseEmulation(false)
            self.isShowingMenu = false
            self.enableControllerInput(false)
        }))

        // Present
        if traitCollection.userInterfaceIdiom == .pad {
            actionSheet.popoverPresentationController?.sourceView = menuButton
            actionSheet.popoverPresentationController?.sourceRect = menuButton?.bounds ?? .zero
        }

        present(actionSheet, animated: true) {
            PVControllerManager.shared.iCadeController?.refreshListener()
        }
    }
}
