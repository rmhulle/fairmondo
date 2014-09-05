class FastbillWorker
  include Sidekiq::Worker

  sidekiq_options queue: :fastbill,
                  retry: 20, # this means approx 6 days
                  backtrace: true

  def perform(id)
    bt = BusinessTransaction.find(id)
    # Start the fastbill chain, to create invoices and add items to invoice
    FastbillAPI.fastbill_chain(bt)
  end
end
