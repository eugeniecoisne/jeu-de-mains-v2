class FeeInvoicesController < ApplicationController
  def create
    @fee_invoice = FeeInvoice.new(fee_invoice_params)
    authorize @fee_invoice
    @fee_invoice.save
    redirect_back fallback_location: root_path
  end

  def destroy
    @fee_invoice = FeeInvoice.find(params[:id])
    @fee_invoice.destroy
    redirect_back fallback_location: root_path
  end

  private

  def fee_invoice_params
    params.require(:fee_invoice).permit(:profile_id, :start_date, :end_date)
  end
end
